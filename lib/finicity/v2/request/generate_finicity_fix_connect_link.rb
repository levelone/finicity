module Finicity::V2
  module Request
    class GenerateFinicityFixConnectLink
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      attr_accessor :customer_id, :token, :institution_login_id, :experience

      def initialize(token, customer_id, institution_login_id, experience)
        @customer_id = customer_id
        @token = token
        @institution_login_id = institution_login_id
        @experience = experience
      end

      def generate_link
        http_client.post(url, body, headers)
      end

      def body
        data = {
          partnerId: ::Finicity.config.partner_id,
          customerId: "#{customer_id}"
        }

        if institution_login_id.present?
          data[:institutionLoginId] = institution_login_id
        end

        if experience.present?
          data[:experience] = experience
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
          'connect/v2/generate/fix'
        )
      end
    end
  end
end
