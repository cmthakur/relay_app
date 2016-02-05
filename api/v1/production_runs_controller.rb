require_relative '../../lib/run_utility'

module API
  module V1
    class ProductionRunsController < Grape::API
      include Grape::Kaminari
      include RunUtility

      resource :runs do
        paginate per_page: 50, max_per_page: 100


        desc 'this route description'
        get '/' do
        end

        desc 'this route description'
        post '/' do
         # => params
         #  {
         #   "line_id": "M4tCqxaL5tYou",
         #   "callback_url": "https://username:password@api.yourdomain.com/v2/result",
         #   "units": [
         #    {
         #     "identifier": "0000001",
         #     "image_url": "http://yourdomain.com/assets/image_0000001.png",
         #     "company": "Microsoft"
         #     },
         #     {
         #       "identifier": "0000002",
         #       "image_url": "http://yourdomain.com/assets/image_0000002.png",
         #       "company": "Google"
         #     }
         #   ]
         # }

         response = RunUtility.verify_request(params)
         # if response.blank?
           response = ProductionRun.new(params).save
         # end

         response
       end
     end
   end
 end
end
