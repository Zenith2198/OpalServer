import json
from prisma import Prisma

from quart import Quart

import logging
logging.basicConfig()
logging.getLogger('prisma').setLevel(logging.DEBUG)

app = Quart(__name__)


@app.route("/")
async def hello_world():
	projects = None
	async with Prisma() as prisma:
		projects = await prisma.project.find_many()

	return json.dumps(list(map(lambda proj: proj.model_dump_json(), projects)))

# For local testing, enable this line
# app.run()
