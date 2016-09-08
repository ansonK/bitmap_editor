RSpec.shared_examples 'a command that requires a bitmap' do
  it 'prints an error when no bitmap has been created' do
    expect { subject.execute_input command }.to output("Error: No Image has been created - please create an Image first\n").to_stdout
  end
end
