import * as bsky from '@atproto/bsky'
import { IdResolver, MemoryCache } from '@atproto/identity'
const run = async () => {
  const db = new bsky.Database({
    url: process.env.POSTGRES_URL || '',
    schema: process.env.POSTGRES_SCHEMA,
    poolSize: parseInt(process.env.POSTGRES_POOL_SIZE || '10', 10),
  })

  // NOTE(luna): has to be done manually here, server doesn't migrate automatically
  await db.migrateToLatestOrThrow()

  const dataplanePort = parseInt(process.env.DATAPLANE_PORT || '2671', 10)
  const plcUrl = process.env.DID_PLC_URL || 'http://localhost:2582'
  const dataplane = await bsky.DataPlaneServer.create(db, dataplanePort, plcUrl)

  const relayWebsocket =
    process.env.RELAY_WEBSOCKET_URL || 'fail_to_connect lol'
  console.log('starting repo subscription from luna script!')

  // repo subscription requires an idResolver too
  const didCache = new MemoryCache()
  const idResolver = new IdResolver({ plcUrl: plcUrl, didCache })
  const sub = new bsky.RepoSubscription({
    service: relayWebsocket,
    db,
    idResolver: idResolver,
  })
  sub.start()

  console.log('dataplane:', dataplane)
  console.log('running on port', dataplanePort)
  process.on('SIGTERM', async () => {
    await dataplane.destroy()
  })
}

run()
