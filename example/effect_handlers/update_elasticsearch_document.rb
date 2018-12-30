# frozen_string_literal: true

module Example
  class UpdateElasticsearchDocument < Bullet::EffectHandler
    option :elasticsearch
    option :index_suffix, default: proc { '' }

    def call(effect)
      index_name = "#{effect.entity_type}#{index_suffix}"
      elasticsearch.update(
        index: index_name,
        type: 'doc',
        id: effect.entity[:id],
        body: {
          doc_as_upsert: true,
          doc: effect.entity.to_h
        }
      )
    end
  end
end
