import json
from prisma import Prisma
import jwt

from quart import Quart, request

app = Quart(__name__)


@app.route("/")
async def hello_world():
	projects = None
	async with Prisma() as prisma:
		projects = await prisma.project.find_many()

	return json.dumps(list(map(lambda proj: proj.model_dump_json(), projects)))

@app.route("/admin", methods=["POST"])
async def admin():
	await request.get_json()

# To run locally, activate this line
# app.run()
