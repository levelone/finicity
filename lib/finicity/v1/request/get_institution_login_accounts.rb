module Finicity::V1
  module Request
    class GetInstitutionLoginAccounts
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      attr_accessor :customer_id, :institution_login_id, :token

      def initialize(token, customer_id, institution_login_id)
        @customer_id = customer_id
        @institution_login_id = institution_login_id
        @token = token
      end

      def get_accounts
        http_client.get(url, nil, headers)
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
          'v1/',
          'customers/',
          "#{customer_id}/",
          'institutionLogins/',
          "#{institution_login_id}/",
          'accounts'
        )
      end
    end
  end
end
