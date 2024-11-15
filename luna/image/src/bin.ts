import * as bsky from '@atproto/bsky'

const run = async () => {
  const imgProcessingCache = new bsky.BlobDiskCache('/tmp/blob_cache_loc')
  let imgProcessingServer = new bsky.ImageProcessingServer(
    {
      localUrl: process.env.APPVIEW_URL || '',
    } as unknown as bsky.ServerConfig,
    imgProcessingCache,
  )
  const port = process.env.PORT || 3000
  imgProcessingServer.app.set('port', port)

  imgProcessingServer.app.listen(port, () => {
    console.log(`image cdn listening on port ${port}`)
  })
}

run()
