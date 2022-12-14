import { Context } from 'oak/mod.ts';

// "LogResponseTimeMiddleware" must be attached first
export async function logResponseTimeMiddleware(ctx: Context, next: () => Promise<unknown>) {
  await next();
  const rt = ctx.response.headers.get('X-Response-Time');
  console.log(`${ctx.request.method} ${ctx.request.url} - ${rt}`);
}

export async function setXResponseTimeMiddleware(ctx: Context, next: () => Promise<unknown>) {
  const start = Date.now();
  await next();
  const ms = Date.now() - start;
  ctx.response.headers.set('X-Response-Time', `${ms}ms`);
}
