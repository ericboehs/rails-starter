# Formats US phone numbers into (XXX) XXX-XXXX display format
class PhoneFormatter
  def self.call(phone)
    return nil if phone.blank?

    raw_digits = phone.gsub(/\D/, "")
    digits = raw_digits.start_with?("1") && raw_digits.length == 11 ? raw_digits[1..] : raw_digits

    return phone unless digits.length == 10

    "(#{digits[0..2]}) #{digits[3..5]}-#{digits[6..9]}"
  end
end
