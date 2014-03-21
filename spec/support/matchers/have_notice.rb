RSpec::Matchers.define :have_notice do |message|
  match do |page|
    page.should have_selector('.alert-notice', text: message)
  end
end
