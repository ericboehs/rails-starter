# Base module for application-wide view helpers
module ApplicationHelper
  def nav_link(label, path)
    if current_page?(path)
      link_to path, class: "inline-flex items-center border-b-2 border-emerald-500 px-1 pt-1 text-sm font-medium text-gray-900 dark:text-white hover:no-underline", "aria-current": "page" do
        label
      end
    else
      link_to label, path, class: "inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700 dark:text-gray-300 dark:hover:text-white"
    end
  end

  def mobile_nav_link(label, path)
    if current_page?(path)
      link_to path, class: "block border-l-4 border-emerald-500 bg-emerald-50 dark:bg-gray-900 py-2 pl-3 pr-4 text-base font-medium text-emerald-700 dark:text-white dark:border-none dark:rounded-md", "aria-current": "page" do
        label
      end
    else
      link_to label, path, class: "block border-l-4 border-transparent py-2 pl-3 pr-4 text-base font-medium text-gray-500 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-700 dark:text-gray-300 dark:hover:bg-gray-700 dark:hover:text-white"
    end
  end

  def format_phone(phone)
    return nil if phone.blank?

    raw_digits = phone.gsub(/\D/, "")
    digits = raw_digits.start_with?("1") && raw_digits.length == 11 ? raw_digits[1..] : raw_digits

    return phone unless digits.length == 10

    "(#{digits[0..2]}) #{digits[3..5]}-#{digits[6..9]}"
  end
end
