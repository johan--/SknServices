##
# <Rails.root>/config/warden.rb
# Configures Warden to be user as a Rack level security manager
#
# Author: James Scott, Jr. <skoona@gmail.com>
# Date: 3.13.2013
#
#
#  Refs: https://github.com/hassox/warden/wiki/Callbacks
#     ***http://pothibo.com/2013/07/authentication-with-warden-devise-less/
#        http://blog.maestrano.com/rails-api-authentication-with-warden-without-devise/
#        https://github.com/ajsharp/warden-rspec-rails
#        https://github.com/hassox/warden/wiki
#
# 'use Rack::Session::Cookie, :secret => "replace this with some secret key"'
##
# Main configuration
##
##
# OBJECTIVE:  Authenticate the user of every request !
#
# Allow Remember Me tokens to be used to sign in; prefer them over passwords
#
# This module along with the modules authentication_controller_helper, authentication_user_helper implement
# the desired security model with a minimum of impact on the ApplicationController[s] or User objects.
#
#
# CONTROLS:
# app/initializers/session_store set the Timeout of 30 minutes on Session Cookie (which is signed with domain)
# this file creates a permanent.signed remember_token with 8.hour expiration, set for http in dev, https(:secure) in production

# * When a cookie expires is is deleted by the browser, and never sent back
# * We intend for the session cookie to expire after 30 minutes, and have the token automatically sign them in again for
#   up to 8 hours.
# * Signing out deletes all cookies/tokens.  I.E. User is done using the system for a while.
#
# SEQUENCES: A
# deserialize() remember_token from session if session and/or keys exists
#   fetch() from Users UsersCache, set_user if found
#   after_failed_fetch() likely caused by invalid token, clear all cookies
# on_request() if user or excluded paths, then pass
#   if remember_token and no user, attempt warden.authenticate() with token, which will set_user
# ApplicationController#before_filter()  Redirect to SignIn if no user was set (save original to session)
#   SignIn get username/password then calls warden.authenticate() with credentials
#   Redirect to original Controller#Action or Pages#Home performed
# ** In either case when user is successfully set a callback:
#    on_authentication() is called which will add user to fetchable list
#
# SEQUENCES: B
# -- next request (user present)
# deserialize(), on_request(), controller#action, repeat until sign out(SEQUENCE C) or session-timeout(SEQUENCES: A)
#
# SEQUENCES: C
# -- SignOut
#   SignOut handled by Sessions#Destroy() and warden.logout()
#   logout causes callback: before_logout() to run and remove user from fetch cache and deletes all cookies
#
##


# Rails.application.config.middleware.use Warden::Manager do |manager|
Rails.application.config.middleware.insert_after ActionDispatch::ParamsParser, RailsWarden::Manager do |manager|
  manager.default_strategies :password, :remember_token, :not_authorized
  manager.failure_app = lambda {|env| SessionsController.action(:new).call(env) }
end

class Warden::SessionSerializer
  ##
  # Save the User id to session store
  def serialize(record)
    #Rails.logger.debug " Warden::SessionSerializer.serialize(ONLY) session.id=#{request.session_options[:id]}, user=#{record.name if record.present?}"
    [record.class.name, record.person_authenticated_key]
  end

  ##
  # Restore a klass name and id from session store
  # Use token to find the existing object
  def deserialize(keys)
    klass, token = keys
    user = klass.to_s.classify.constantize.fetch_cached_user( token )
    # Rails.logger.debug " Warden::SessionSerializer.deserialize(ONLY) session.id=#{request.session_options[:id]}, user=#{user.name if user.present?}"
    user
  end
end

##
# Use the fields from the Signin page to authorize user
Warden::Strategies.add(:password) do
  def auth
    @auth ||= Rack::Auth::Basic::Request.new(env)
  end
  def valid?
    return false if request.get?
    params["session"].has_key?("username") and params["session"].has_key?("password") and
        params["session"]["username"].present? and params["session"]["password"].present?
  end

  def authenticate!
    user = User.find_by_username(params["session"]["username"]).try(:authenticate, params["session"]["password"])
    (user.present? and user.active?) ? success!(user, "Signed in successfully.") : fail!("Your Credentials are invalid or expired. Invalid username or password!")
  rescue
    fail!("Your Credentials are invalid or expired.")
  end
end

##
# Use the remember_token from the requests cookies to authorize user
Warden::Strategies.add(:remember_token) do
  def valid?
    request.cookies["remember_token"].present?
  end

  def authenticate!
    remember_token = request.cookies["remember_token"]
    token = Marshal.load(Base64.decode64(CGI.unescape(remember_token.split("\n").join).split('--').first)) if remember_token
    user = User.fetch_remembered_user(token)
    (user.present? and user.active?) ? success!(user, "Signed in successfully.") : fail!("Your Credentials are invalid or expired. Token Invaild!")
  rescue
    fail!("Your Credentials are invalid or expired. Token Invaild!")
  end
end

Warden::Strategies.add(:basic_auth) do
  def auth
    @auth ||= Rack::Auth::Basic::Request.new(env)
  end

  def valid?
    auth.provided? && auth.basic? && auth.credentials
  end

  def authenticate!
    user = User.find_by_username(auth.credentials[0])
    user.try(:authenticate,auth.credentials[1])
    (user.present? and user.active?) ? success!(user, "Signed in successfully.") : fail!("Your Credentials are invalid or expired. Invalid username or password!")
   rescue
    fail!("Your Credentials are invalid or expired.  Auth Invaild!")
  end
end

##
# This will always fail, and is used as the last option should prior options fail
Warden::Strategies.add(:not_authorized) do
  def valid?
    true
  end

  def authenticate!
    fail!("Your Credentials are invalid or expired. Not Authorized!")
  end
end

##
# IF NO CURRENT USER PRESENT
# if remember me token is present
#    attempt to authenticate using token, fail to signin page, else pass
Warden::Manager.on_request do |proxy|
  Rails.logger.debug " Warden::Manager.on_request(ENTER) userId=#{proxy.user.name if proxy.user.present?}, original_fullpath=#{proxy.request.original_fullpath}, session.keys=#{proxy.raw_session.keys}"

  tstatus = false
  full_path = proxy.request.original_fullpath
  bypass = full_path.eql?("/") || AccessRegistry.security_check?(full_path)

  unless proxy.authenticated? or bypass
    proxy.authenticate(:remember_token)      # sets user if successful
    unless proxy.authenticated?    # Controllers's login_required? will sort this out
      proxy.request.flash.clear
      proxy.request.flash.notice = "Please sign in to continue."
      tstatus = true
    end
  end

  Rails.logger.debug " Warden::Manager.on_request(EXIT) bypass=#{bypass}, redirected=#{tstatus}, userId=#{proxy.user.name if proxy.user.present?}, token=#{proxy.cookies['remember_token'].present?}, path_info=#{proxy.request.fullpath}, sessionId=#{proxy.request.session_options[:id]}"
end

Warden::Manager.after_set_user do |user, auth, opts|
  unless !User.last_login_time_expired?(user) && user.active?
    auth.logout
    throw(:warden, :message => "Session Expired! Please sign in to continue.")
  end
end

##
# Set remember_token only after a signin
Warden::Manager.after_authentication do |user,auth,opts|
  remember = false
  remember = true if auth.request.params.key?("session") && "1".eql?(auth.request.params["session"]["remember_me_token"])
  user.enable_authentication_controls

  if remember
    if Rails.env.production?
      auth.cookies.permanent.signed[:remember_token] = { value: user.remember_token, domain: auth.env["SERVER_NAME"], expires: Settings.security.session_expires, httponly: true, secure: true }
    else
      auth.cookies.permanent.signed[:remember_token] = { value: user.remember_token, domain: auth.env["SERVER_NAME"], expires: Settings.security.remembered_for, httponly: true }
    end
  else
    auth.cookies.delete :remember_token, domain: auth.env["SERVER_NAME"]
  end
  Rails.logger.debug %Q! Warden::Manager.after_authentication(ONLY, token=#{remember ? true : false}) user=#{user.name unless user.nil?}, Host=#{auth.env["SERVER_NAME"]}, session.id=#{auth.request.session_options[:id]} !
end

##
# Called in no user has be fetch and set as the current user
Warden::Manager.after_failed_fetch do |user,auth,opts|
  Rails.logger.debug " Warden::Manager.after_failed_fetch(ONLY) remember_token present?(#{auth.cookies["remember_token"].present?}), user=#{user.name unless user.nil?}, session.id=#{auth.request.session_options[:id]}"
  auth.cookies.delete '_SknServices_session'.to_sym, domain: auth.env["SERVER_NAME"]
end

##
# Injects the new action to match SessionsController
Warden::Manager.before_failure do |env, opts|
  Rails.logger.debug " Warden::Manager.before_failure(ONLY) session.id=#{env['warden'].request.session_options[:id]}"
  env['warden'].cookies.delete :remember_token, domain: env['warden'].env["SERVER_NAME"]
  env['action_dispatch.request.path_parameters'][:action] = "new"
end

##
# Logout the user object
Warden::Manager.before_logout do |user,auth,opts|
  user.disable_authentication_controls unless user.nil?
  auth.cookies.delete '_SknServices_session'.to_sym, domain: auth.env["SERVER_NAME"]
  auth.cookies.delete :remember_token, domain: auth.env["SERVER_NAME"]
  auth.reset_session!
  Rails.logger.debug " Warden::Manager.before_logout(ONLY) user=#{user.name unless user.nil?}, Host=#{auth.env["SERVER_NAME"]}, session.id=#{auth.request.session_options[:id]}"
end
