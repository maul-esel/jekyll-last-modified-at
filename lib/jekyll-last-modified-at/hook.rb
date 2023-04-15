# frozen_string_literal: true

module Jekyll
  module LastModifiedAt
    module Hook
      def self.add_determinator_proc
        proc { |item|
          format = item.site.config.dig('last-modified-at', 'date-format')

          dependencies = (item.data['lastmod_dependencies'] || {}).clone
          if dependencies.has_key?('collections')
            dependencies['collections'] = dependencies['collections'].map { |c| item.site.collections[c] }
          end

          item.data['last_modified_at'] = Determinator.new(item.site.source, dependencies,
                                                           item.path, format)
        }
      end

      Jekyll::Hooks.register :posts, :post_init, &Hook.add_determinator_proc
      Jekyll::Hooks.register :pages, :post_init, &Hook.add_determinator_proc
      Jekyll::Hooks.register :documents, :post_init, &Hook.add_determinator_proc
    end
  end
end
