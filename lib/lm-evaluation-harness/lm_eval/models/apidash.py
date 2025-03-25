from operator import itemgetter
from dotenv import load_dotenv
import os
from pathlib import Path
from lm_eval.models.api_models import TemplateAPI
from lm_eval.api.registry import register_model

@register_model("apidash")
class ApidashInterface(TemplateAPI):
    def __init__(self, model, base_url, api_key, **kwargs):
        super().__init__(model=model, base_url=base_url, tokenizer_backend="tiktoken", **kwargs)

        self.api_key = api_key

    def _create_payload(self, prompt, generate=False, **kwargs):
        payload = {
            "model": self.model,
            "prompt": prompt,
        }
        if not generate:
            payload["logprobs"] = kwargs.get("logprobs", 1)
        return payload
    
    @staticmethod
    def parse_generations(outputs, **kwargs):
        return [outputs.get("choices", "").get("message", "").get("content", "")]
    
    @staticmethod
    def parse_logprobs(outputs, tokens=None, ctxlens=None, **kwargs):
        res = []
        if not isinstance(outputs, list):
            outputs = [outputs]
        for out in outputs:
            for choice, ctxlen in zip(
                sorted(out["choices"], key=itemgetter("index")), ctxlens
            ):
                assert ctxlen > 0, "Context length must be greater than 0"
                logprobs = sum(choice["logprobs"]["token_logprobs"][ctxlen:-1])
                tokens_logprobs = choice["logprobs"]["token_logprobs"][ctxlen:-1]
                top_logprobs = choice["logprobs"]["top_logprobs"][ctxlen:-1]
                is_greedy = True
                for tok, top in zip(tokens_logprobs, top_logprobs):
                    if tok != max(top.values()):
                        is_greedy = False
                        break
                res.append((logprobs, is_greedy))
        return res
    
    def headers(self):
        return {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + str(self.api_key),
        }
