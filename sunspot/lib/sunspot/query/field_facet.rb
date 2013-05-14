module Sunspot
  module Query
    class FieldFacet < AbstractFieldFacet
      def initialize(field, options)
        @local_params = {}

        if exclude_filters = options[:exclude]
          @local_params[:ex] = Util.Array(exclude_filters).map do |filter|
            filter.tag
          end.join(',')
        end

        if options[:name]
          @local_params[:key] = options[:name]
          @local_params[:'facet.prefix'] = options[:prefix] if options.has_key?(:prefix)
          @local_params[:'facet.mincount'] = options[:minimum_count] if options.has_key?(:minimum_count)
          @local_params[:'facet.sort'] = options[:sort] if options.has_key?(:sort)
        end

        super
      end

      def to_params
        super.merge(:"facet.field" => [field_name_with_local_params])
      end

      private

      attr_reader :local_params

      def field_name_with_local_params
        if local_params.empty?
          @field.indexed_name
        else
          pairs = local_params.map do |key, value|
            "#{key}=#{value}"
          end
          "{!#{pairs.join(' ')}}#{@field.indexed_name}"
        end
      end
    end
  end
end
