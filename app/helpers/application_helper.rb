module ApplicationHelper
  BOOTSTRAP_FLASH_MSG = {
    success: 'alert-success',
    notice: 'alert-info', # by rails
    warning: 'alert-warning',
    alert: 'alert-warning', # by rails
    error: 'alert-danger'
  }.freeze

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type.to_sym, flash_type.to_s)
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(
        content_tag(
          :div,
          message,
          class: "text-center alert #{bootstrap_class_for(msg_type)} fade in"
        ) do
          concat content_tag(:button, 'X'.html_safe, class: 'close', data: { dismiss: 'alert' })
          concat message
        end
      )
      flash.clear
    end
    nil
  end
end
