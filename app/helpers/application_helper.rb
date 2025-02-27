# frozen_string_literal: true

module ApplicationHelper
  def tailwind_class_for(flash_type)
    case flash_type.to_sym
    when :notice
      'bg-green-100 border-green-400 text-green-700'
    when :alert
      'bg-red-100 border-red-400 text-red-700'
    else
      'bg-blue-100 border-blue-400 text-blue-700'
    end
  end
end
