module Finicity::V1
  module Request
    class GenerateFinicityConnectLink
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      attr_accessor :customer_id, :token, :redirect_uri, :oauth_support, :autoreplace, :institutions

      def initialize(token, customer_id, redirect_uri, oauth_support, autoreplace, institutions)
        @customer_id = customer_id
        @token = token
        @redirect_uri = redirect_uri
        @oauth_support = oauth_support
        @autoreplace = autoreplace
        @institutions = institutions
      end

      def generate_link
        http_client.post(url, body, headers)
      end

      def body
        data = {
          partnerId: ::Finicity.config.partner_id,
          customerId: "#{customer_id}",
          redirectUri: redirect_uri,
          type: 'aggregation'
        }

        if oauth_support
          if autoreplace
            data[:oauthOptions] = {
              enabled: oauth_support,
              autoReplace: autoreplace
            }
          else
            data[:oauthOptions] = {
              enabled:  oauth_support,
              institutions: institutions
            }
          end
        end
        
        data.to_json
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Finicity-App-Token' => token,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
      end
      
      def url
        ::URI.join(
          ::Finicity.config.base_url,
          'connect/v1/generate'
        )
      end
    end
  end
end
