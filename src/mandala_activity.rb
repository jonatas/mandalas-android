require 'ruboto/widget'
require 'ruboto/util/toast'

ruboto_import_widgets :Button, :LinearLayout, :TextView, :ImageView


class MandalaActivity
  def onCreate(bundle)
    super
    set_title 'Mandalas Panel'

      self.content_view = linear_layout do
        image_view :image_resource => $package::R.drawable.mandala_1_01b, 
                   :scale_type => ImageView::ScaleType::FIT_CENTER,
                   :layout => {
                     :weight= => 1,
                     :height= => :fill_parent,
                     :width= => :fill_parent}
      end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end



end
