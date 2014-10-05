Bundler.require

OLDHOST = 'theongaku.jp'
NEWHOST = 'japan.theongaku.com'

class RedirectController < ActionController::Base
  def pages
    redirect_to url, status: :moved_permanently
  end

  private

  def url
    location = params.except(:controller, :action)
    path = location.delete(:path)
    [ "//#{NEWHOST}/#{path}", location.to_param ].join('?')
  end
end

run MrRedirector ||= Class.new(Rails::Application) {
  config.secret_key_base = routes.append {
    constraints(host: OLDHOST) {
      root to: "redirect#pages"
      get "/*path" => "redirect#pages"
    }
  }.to_s
  initialize!
}
