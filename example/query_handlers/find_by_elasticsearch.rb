# frozen_string_literal: true

module Example
  class FindByElasticsearch < Bullet::QueryHandler
    option :elasticsearch
    option :index_suffix, default: proc { '' }

    def call(query)
      if query.conditions.keys == %i[id]
        fetch_by_id(query)
      else
        fetch_by_query(query)
      end
    end

    private

    def fetch_by_id(query)
      elasticsearch.get(
        index: index_name(query),
        id: query.conditions[:id],
        ignore: [404]
      ).dig('_source')
    end

    def fetch_by_query(query)
      elasticsearch.search(
        index: index_name(query),
        body: build_search_query(query)
      ).dig('hits', 'hits', 0)
    end

    def index_name(query)
      "#{query.type}#{index_suffix}"
    end

    def build_search_query(query)
      {
        query: {
          bool: {
            must: query.conditions.map do |(term, value)|
              { term: { term => value } }
            end
          }
        }
      }
    end
  end
end
