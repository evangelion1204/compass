module Compass
  module SassExtensions
    module Sprites
      module Layout
        class BinTree < SpriteLayout

          def layout!
            calculate_positions!
          end

        private # ===========================================================================================>i

          def prepare!
            @images = @images.sort do |a, b|
              if a.height == b.height
                b.width <=> a.width
              else
                b.height <=> a.height
              end
            end
          end

          def create_node(x, y, w, h)
            {:x => x, :y => y, :w => w, :h => h}
          end

          def split_node(root, image)
            root[:right] = create_node(root[:x] + image.width, root[:y], root[:w] - image.width, image.height)
            root[:left] = create_node(root[:x], root[:y] + image.height, root[:w], root[:h] - image.height)
            root[:image] = image
            root
          end

          def find_node(root, image)
            if root[:image]
              return find_node(root[:right], image) || find_node(root[:left], image)
            end
            if image.width <= root[:w] && image.height <= root[:h]
              return split_node(root, image)
            end
          end

          def apply_layout
            width = @images.collect(&:width).max
            height = @images.collect(&:height).max * @images.length

            root = create_node 0, 0, width, height
            max_height = 0
            @images.each_with_index do |image, index|
              node = find_node(root, image)
              image.top = node[:y]
              image.left = node[:x]
              max_height = node[:y] + image.height if max_height < node[:y] + image.height
            end

            @width = root[:w]
            @height = max_height
          end 

          def calculate_positions!
            prepare!
            apply_layout
          end

        end
      end
    end
  end
end
