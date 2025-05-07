import json
import requests

def lambda_handler(event, context):
    try: 
        url = "https://xb7p4evk8i.execute-api.us-east-1.amazonaws.com/dev/calculatebedrockllmcost"
        data = {
            "llm": {
                "name": "haiku 35",
                "input_tokens": 70000,
                "output_tokens": 1000,
                "number_of_requests": 1000000
            }
        }

        response = requests.post(url, json=data)
        try:
            response_data = response.json()
        except ValueError:
            response_data = response.text

        return {
            "statusCode": response.status_code,
            "body": json.dumps({
                "message": "Success",
                "input": response_data
            })
        }
    except Exception as e:
        print("Erro:", e)
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Internal Error", "error": str(e)})
        }
