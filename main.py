import json
from prisma import Prisma
import jwt
import os
import requests
from time import time

from dotenv import load_dotenv
load_dotenv()

from quart import Quart, request

app = Quart(__name__)

URLS = ["http://localhost:3000", "https://opal-ochre.vercel.app"]


# Helpers
def authenticate(encodedJWT):
	try:
		decoded = jwt.decode(encodedJWT, os.getenv("CLERK_PEM_PUBLIC_KEY"), algorithms="RS256")
		inTime = decoded["nbf"] < time() < decoded["exp"]
		fromValidSource = "azp" in decoded and decoded["azp"] in URLS
		return inTime and fromValidSource
	except:
		return False


# Route handlers
@app.route("/")
async def hello_world():
	try:
		projects = None
		async with Prisma() as prisma:
			projects = await prisma.project.find_many()

		return json.dumps(list(map(lambda proj: proj.model_dump_json(), projects)))
	except:
		return "Database error", 500


@app.route("/admin", methods=["POST"])
async def admin():
	try:
		req = await request.get_json()
		auth = authenticate(req["jwt"])
		return json.dumps({ "authenticated": auth })
	except:
		return "Invalid request", 400


# To run locally, activate this line
# app.run()
