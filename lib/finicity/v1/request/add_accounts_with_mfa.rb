module Finicity::V1
  module Request
    class AddAccountsWithMfa
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :token, :customer_id, :institution_id, :mfa_session, :mfa_answer

      ##
      # Instance Methods
      #
      def initialize(token, customer_id, institution_id, mfa_session, mfa_answer=[])
        @mfa_answer = mfa_answer
        @customer_id = customer_id
        @institution_id = institution_id
        @mfa_session = mfa_session
        @token = token
      end

      # The accounts parameter is the finicity representation of accounts
      def add_accounts_with_mfa
        http_client.post(url, body, headers)
      end

      # The accounts parameter is the finicity representation of accounts
      def body
        {
          'mfaChallenges' => {
            'questions' => mfa_answer
          }
        }.to_json
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Finicity-App-Token' => token,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'MFA-Session' => mfa_session
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
          'addall/',
          'mfa'
        )
      end
    end
  end
end
