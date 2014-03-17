RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('.alert-error', text: message)
  end
end
