module Finicity::V2
  module Request
    class GetInstitutionById
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :institution_id, :token

      ##
      # Instance Methods
      #
      def initialize(token, institution_id)
        @institution_id = institution_id
        @token = token
      end

      def get_institution_by_id
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
          'institution/',
          'v2/',
          'institutions/',
          "#{institution_id}/"
        )
      end
    end
  end
end