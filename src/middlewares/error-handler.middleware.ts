import { Context, isHttpError, Status } from 'oak/mod.ts';

export function errorHandlerMiddleware(type: string) {
  return async (ctx: Context, next: () => Promise<unknown>) => {
    console.log(`${'=='.repeat(10)} [DEBUG] Headers ${'=='.repeat(10)}`)
    console.log()
    const headers = ctx.request.headers.entries()
    for (const [key, value] of headers) {
        console.log(key, ' - ', value)
    }
    console.log()
    console.log(`${'=='.repeat(10)} [DEBUG] Headers ${'=='.repeat(10)}`)

    try {
      await next();
    } catch (err) {
      console.log(`[App ${type}]: Middleware Error`);
      if (isHttpError(err)) {
        switch (err.status) {
          case Status.NotFound:
            console.log(`[App ${type}]: Status ', err.statu`);
            ctx.response.body = { message: err.message };
            // handle NotFound
            break;
          default:
            console.log(`[App ${type}]: Status ', err.statu`);
            ctx.response.body = { message: err.message };
            ctx.response.status = err.status;
            return;
            // handle other statuses
        }
      } else {
        // rethrow if you can't handle the error
        console.log(`[App ${type}]: Status ', ${err.status}`);
        throw err;
      }
    }
  };
}
