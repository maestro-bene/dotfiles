import transformers
from torch import bfloat16

model_id = "mistralai/Mixtral-8x7B-Instruct-v0.1"
model = transformers.AutoModelForCausalLM.from_pretrained(
    model_id, trust_remote_code=True, torch_dtype=bfloat16, device_map="auto"
)
model.eval()
tokenizer = transformers.AutoTokenizer.from_pretrained(model_id)
generate_text = transformers.pipeline(
    model=model,
    tokenizer=tokenizer,
    return_full_text=False,  # Set this to True if using langchain
    task="text-generation",
    temperature=0.1,  # Controls the randomness of outputs
    top_p=0.15,  # Probability threshold for selecting tokens
    top_k=0,  # Number of top tokens to consider (0 relies on top_p)
    max_new_tokens=512,  # Limits the number of generated tokens
    repetition_penalty=1.1,  # Discourages repetitive outputs
)

test_prompt = "The future of AI is"
result = generate_text(test_prompt)
print(result[0]["generated_text"])
