#Sknservice
====

### Model Templates

rails generate model NAME [field[:type][:index] field[:type][:index]] [options]
rails generate scaffold NAME [field[:type][:index] field[:type][:index]] [options]


### Model Generation (SimpleForm UI)
***Make sure you edit config/initializers/generators.rb first***

```bash
rails g model Users username:string:index name:string email:string password:digest remember_token:string:index password_reset_token:string password_reset_date:datetime role_groups:string roles:string active:boolean file_access_token:string

rails g scaffold  profile_type     name description
rails g scaffold  content_profile  person_authentication_key:string:uniq profile_type:references authentication_provider username display_name email

rails g scaffold  content_type name description value_data_type
rails g scaffold  content_type_opt value description content_type:references

rails g scaffold  topic_type name description value_based_y_n
rails g scaffold  topic_type_opt  value description topic_type:references

rails g scaffold  content_profile_entry  description topic_value content_value content_type:references topic_type:references content_profile:references

Gem 'annotate'
bundle exec annotate --exclude tests,fixtures,factories,serializers
```


