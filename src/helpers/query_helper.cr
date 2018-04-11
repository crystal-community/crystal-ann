module Helpers::QueryHelper
  def to_query(**query)
    current_params = params.to_h.dup
    query.each { |k, v| current_params[k.to_s] = v.to_s }
    HTTP::Params.encode current_params
  end
end
