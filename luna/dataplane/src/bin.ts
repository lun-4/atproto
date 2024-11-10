import * as bsky from '@atproto/bsky'
const run = async () => {
  const db = new bsky.Database({
    url: process.env.POSTGRES_URL || '',
    schema: process.env.POSTGRES_SCHEMA,
    poolSize: parseInt(process.env.POSTGRES_POOL_SIZE || '10', 10),
  })

  // NOTE(luna): has to be done manually here, server doesn't migrate automatically
  await db.migrateToLatestOrThrow()

  const dataplanePort = parseInt(process.env.DATAPLANE_PORT || '2671', 10)
  const dataplane = await bsky.DataPlaneServer.create(
    db,
    dataplanePort,
    process.env.DID_PLC_URL || 'http://localhost:2582',
  )
  console.log('dataplane:', dataplane)
  console.log('running on port', dataplanePort)
  process.on('SIGTERM', async () => {
    await dataplane.destroy()
  })
}

run()
