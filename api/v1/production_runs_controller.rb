module API
  module V1
    class ProductionRunsController < Grape::API
      include Grape::Kaminari

      resource :runs do
        paginate per_page: 50, max_per_page: 100

        desc 'this route description'
        get '/' do
      end
    end
  end
end
