RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('.alert-success', text: message)
  end
end
