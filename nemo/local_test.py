# Run from inside nemo directory for local config
import os
from nemoguardrails import LLMRails, RailsConfig

# Load local config
config = RailsConfig.from_path(os.path.join(os.getcwd(), "pii_detect_config"))

# Initialize the rails engine
rails = LLMRails(config)

# For hello_world_config
# response = rails.generate("Who are you?")
# print(response)

# For pii_detect_config
response = rails.generate(messages=[{"role": "user", "content": "Who are you?"}])
print("FINAL RESPONSE", response)

response = rails.generate(
    messages=[{"role": "user", "content": "There is an email here: bob@gmail.com"}]
)
print("FINAL RESPONSE", response)
