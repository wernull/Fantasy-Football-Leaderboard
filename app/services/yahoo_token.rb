# token helpers for yahoo api
class YahooToken
  def self.request_token
    oauth_consumer.get_request_token(oauth_callback: Rails.application.config.yahoo_callback)
  end

  def self.access_token(user)
    consumer = oauth_consumer
    token_data = JSON.parse(user.yahoo_token)

    token = OAuth::Token.new(token_data['token'], token_data['token_secret'])

    if DateTime.parse(token_data['updated_at']) + 1.hour < DateTime.current
      token_hash = consumer.token_request(
        :get,
        consumer.access_token_path,
        token,
        oauth_session_handle: token_data['session_handle']
      )

      access_token = OAuth::AccessToken.from_hash(consumer, token_hash)

      token_data = {
        token: access_token.params['oauth_token'],
        token_secret: access_token.params['oauth_token_secret'],
        session_handle: access_token.params['oauth_session_handle'],
        updated_at: DateTime.current
      }

      user.update_columns(yahoo_token: token_data.to_json)
    else
      access_token = OAuth::AccessToken.from_hash(
        consumer,
        oauth_token: token_data['token'],
        oauth_token_secret: token_data['token_secret']
      )
    end

    access_token
  end

  def self.oauth_consumer
    OAuth::Consumer.new(
      Rails.application.config.yahoo_key,
      Rails.application.config.yahoo_secret,
      site: 'https://api.login.yahoo.com',
      scheme: :query_string,
      http_method: :get,
      request_token_path: '/oauth/v2/get_request_token',
      access_token_path: '/oauth/v2/get_token',
      authorize_path: '/oauth/v2/request_auth'
    )
  end
end
