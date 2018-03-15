module Requests
  module JsonHelpers
    def json
      @json ||= if response.body.present?
        JSON.parse(response.body)
      end
    end

    RSpec::Matchers.define :contain_exactly_jsonapi_resources do |type, *ids|
      ids = ids.flatten
      match do |actual|
        actual_types = extract_jsonapi_types(json)
        actual_ids = extract_jsonapi_ids(json)
        if actual_types.count == 1 && actual_types.first == type
          ids.all? { |i| actual_ids.include?(i.to_s) } && ids.length == actual_ids.length
        end
      end
      failure_message do |actual|
        actual_types = extract_jsonapi_types(json)
        actual_ids = extract_jsonapi_ids(json)
        if actual_types.count > 1
          "expected one type #{type}, but found #{actual_types.inspect}"
        elsif actual_types.first != type
          "expected to find #{type}, but found #{actual_types.first || 'no results'}"
        else
          "expected to find object with IDs #{ids.inspect}, but got #{actual_ids.inspect}"
        end
      end
    end

    def extract_jsonapi_ids(json)
      Array.wrap(json["data"]).map {|h| h["id"] }
    end

    def extract_jsonapi_types(json)
      Array.wrap(json["data"]).map { |h| h["type"] }.uniq
    end
  end
end
