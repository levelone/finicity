module Finicity::V1
  module Request
    class DiscoverAccountsWithMfa
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :customer_id,
        :institution_id,
        :mfa_credentials,
        :mfa_session_id,
        :token

      ##
      # Instance Methods
      #
      def initialize(token, mfa_session_id, customer_id, institution_id, mfa_credentials=[])
        @customer_id = customer_id
        @institution_id = institution_id
        @mfa_credentials = mfa_credentials
        @mfa_session_id = mfa_session_id
        @token = token
      end

      def discover_accounts_with_mfa
        http_client.post(url, body, headers)
      end

      def body
        {
          'mfaChallenges' => {
            'questions' => mfa_credentials
          }
        }.to_json
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Finicity-App-Token' => token,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'MFA-Session' => mfa_session_id
        }
      end

      def url
        ::URI.join(
          ::Finicity.config.base_url,
          'v1/',
          'customers/',
          "#{customer_id}/",
          'institutions/',
          "#{institution_id}/",
          'accounts/',
          'mfa'
        )
      end
    end
  end
end
