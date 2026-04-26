source "https://rubygems.org"

ruby "3.3.0"

gem "rails", "~> 7.2.0"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "bcrypt", "~> 3.1.7"
gem "jwt", "~> 2.7"
gem "rack-cors"
gem "active_model_serializers", "~> 0.10.0"
gem "redis", "~> 5.0"
gem "sidekiq", "~> 7.0"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "dotenv-rails"
end

group :development do
  gem "annotate"
end

group :production do
  gem "rack-timeout"
end
