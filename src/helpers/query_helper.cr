module Helpers::QueryHelper
  def to_query(current_params = params.raw_params.to_h, **query)
    query.each { |k, v| current_params[k.to_s] = v.to_s }
    HTTP::Params.encode current_params
  end
end
