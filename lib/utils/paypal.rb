require "config"

module Utils
  module Paypal
    class BillingAgreement < Struct.new(:urls); end

    class Plan < Struct.new(:id, :base_uri, :headers, :description)
      def activate
        HTTParty.patch("#{base_uri}/v1/payments/billing-plans/#{id}/", {
          headers: headers,
            body: [{ "op": "replace", "path": "/", "value": { "state": "ACTIVE" } }].to_json
        })
      end
    end

    class Client
      def initialize
        authenticate
      end

      def headers
        {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => auth_header 
        }
      end

      def auth_header
        "Bearer #{@token}"
      end

      def make_billing_agreement(plan)
        response = HTTParty.post("#{base_uri}/v1/payments/billing-agreements", {
          headers: headers,
          body: {
            "name": "#{plan.description}",
            "description": "#{plan.description}",
            "start_date": "#{10.minutes.from_now.utc.iso8601}",
            "plan":
            {
              "id": "#{plan.id}"
            },
            "payer":
            {
              "payment_method": "paypal"
            }
          }.to_json
        })

        BillingAgreement.new(response.parsed_response["links"])
      end

      def make_infinite_monthly_plan(description: "Journmail monthly plan", price: 2, token:)
        return_url = "http://localhost:4567/activate-subscription/#{token}"
        cancel_url = "http://localhost:4567/paypal-problems/#{token}"
        response = HTTParty.post("#{base_uri}/v1/payments/billing-plans/", {
          headers: headers,
          body: {
            "name": "#{description}",
            "description": "#{description}",
            "type": "infinite",
            "payment_definitions": [
              {
                "name": "#{description}",
                "type": "REGULAR",
                "frequency": "MONTH",
                "frequency_interval": "1",
                "amount":
                {
                  "value": "#{price}",
                  "currency": "USD"
                },
                "cycles": "0"
              }],
              "merchant_preferences": {
                "return_url": return_url,
                "cancel_url": cancel_url,
                "auto_bill_amount": "YES",
                "initial_fail_amount_action": "CONTINUE",
                "max_fail_attempts": "0"
              } }.to_json })

        Plan.new(response.parsed_response["id"],
                 base_uri,
                 headers, 
                 description)
      end

      def make_infinite_yearly_plan(description: "Journmail yearly plan", price: 20, token:)
        return_url = "http://localhost:4567/activate-subscription/#{token}"
        cancel_url = "http://localhost:4567/paypal-problems/#{token}"
        response = HTTParty.post("#{base_uri}/v1/payments/billing-plans/", {
          headers: headers,
          body: {
            "name": "#{description}",
            "description": "#{description}",
            "type": "infinite",
            "payment_definitions": [
              {
                "name": "#{description}",
                "type": "REGULAR",
                "frequency": "YEAR",
                "frequency_interval": "1",
                "amount":
                {
                  "value": "#{price}",
                  "currency": "USD"
                },
                "cycles": "0"
              }],
              "merchant_preferences": {
                "return_url": return_url,
                "cancel_url": cancel_url,
                "auto_bill_amount": "YES",
                "initial_fail_amount_action": "CONTINUE",
                "max_fail_attempts": "0"
              } }.to_json })

        Plan.new(response.parsed_response["id"],
                 base_uri,
                 headers, 
                 description)
      end

      def authenticate
        response = HTTParty.post("#{base_uri}/v1/oauth2/token",
                                 body: 'grant_type=client_credentials',
                                 basic_auth: {
                                   username: Settings.paypal.client,
                                   password: Settings.paypal.secret
                                 })

        @token = response.parsed_response["access_token"]
      end

      def execute_agreement(paypal_token)
        HTTParty.post("https://api.sandbox.paypal.com/v1/payments/billing-agreements/#{paypal_token}/agreement-execute",
                      headers: headers)
      end
    end

    class Sandbox < Client
      def base_uri
        "https://api.sandbox.paypal.com"
      end
    end

    class Live < Client
      def base_uri
        "https://api.paypal.com"
      end
    end
  end
end
