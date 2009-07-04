ActionView::Helpers::AssetTagHelper.register_javascript_expansion(
  :unobtrusive=>['lowpro'].concat(Dir.glob(File.join(ActionView::Helpers::AssetTagHelper::JAVASCRIPTS_DIR, 'behaviours', '*.js')).map {|fp| "behaviours/#{File.basename(fp).sub('.js', '')}"}) << 'unobtrusive'
)