# spec/controllers/password_resets_controller_spec.rb

describe PasswordResetsController, " Reset User Password Process" do
  let!(:user) {FactoryGirl.create(:user)} # let!(:user) { user_eptester()}

  before :each do
    sign_in(user, scope: :access_profile)
    # @request.host = 'www.example.com'
  end

  describe "#new requests the username" do
    it "returns http success" do
      get :new
      expect(assigns(:user)).to be_a(User)
      expect(response).to be_success
      expect(response).to render_template :new
    end
  end

  describe "#edit receives the email link to find by reset token" do
    it "returns http success" do
      get :edit, params: {id: user.password_reset_token}
      expect(assigns(:user)).to be_a(User)
      expect(response).to be_success
      expect(response).to render_template :edit
    end
  end

  describe "#update changes the users password" do
    it "redirects to signin page when sucessful" do
      # create a @page_controls object
      good = {
          success: true,
          message: "Password has been reset please sign in"
      }

      # mock out the controller.password_service.reset_password(params)
      # - have it return the @page_controls object
      allow(controller.service_factory.access_service).to receive(:reset_password) {SknUtils::ResultBean.new(good)}

      put :update, params: {id: user.id, user: {password: "somevalue", password_confirmation: "somevalue"}}
      expect(response).to be_redirect
      expect(assigns(:page_controls)).to be_a(SknUtils::ResultBean)
      expect(response).to redirect_to signin_path
    end

    it "renders edit page on error." do
      # create a @page_controls object
      bad = {
          success: false,
          user: user,
          message: "Some Error Message"
      }
      user.password_confirmation = ""
      user.valid?
      # mock out the controller.password_service.reset_password(params)
      # - have it return the @page_controls object
      allow(controller.service_factory.access_service).to receive(:reset_password) {SknUtils::ResultBean.new(bad)}

      put :update, params: {id: user.id, user: {password: "somevalue", password_confirmation: "value"}}
      expect(assigns(:user)).to be_a(User)
      expect(response).to be_success
      expect(assigns(:page_controls)).to be_a(SknUtils::ResultBean)
      expect(response).to render_template :edit
    end
  end

  describe "#create uses the username to send reset email" do
    it "redirects to signin page when sucessful" do
      # create a @page_controls object
      good = {
          success: true,
          message: "Email sent with password reset instructions"
      }
      # mock out the controller.password_service.reset_requested()
      # - have it return the @page_controls object
      allow(controller.service_factory.access_service).to receive(:reset_requested) {SknUtils::ResultBean.new(good)}

      post :create, params: {user: {username: "some-ignored-value"}}
      expect(response).to be_redirect
      expect(assigns(:page_controls)).to be_a(SknUtils::ResultBean)
      expect(response).to redirect_to home_pages_path
    end

    it "redirects to signin page on error" do
      # create a @page_controls object
      bad = {
          success: false,
          message: "PasswordService.reset_requested"
      }
      # mock out the controller.password_service.reset_requested()
      # - have it return the @page_controls object
      allow(controller.service_factory.access_service).to receive(:reset_requested) {SknUtils::ResultBean.new(bad)}

      post :create, params: {user: {username: "some-ignored-value"}}
      expect(response).to be_redirect
      expect(assigns(:page_controls)).to be_a(SknUtils::ResultBean)
      expect(response).to redirect_to home_pages_path
    end
  end

end
