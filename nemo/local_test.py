import os
from nemoguardrails import LLMRails, RailsConfig

# Load local config
config = RailsConfig.from_path(os.path.join(os.getcwd(), "hello_world_config"))

# Initialize the rails engine
rails = LLMRails(config)

response = rails.generate("Who are you?")
print(response)
