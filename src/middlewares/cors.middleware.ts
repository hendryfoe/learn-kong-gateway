import { Context } from 'oak/mod.ts';

export async function corsMiddleware(ctx: Context, next: () => Promise<unknown>) {
  ctx.response.headers.set('Access-Control-Allow-Origin', '*');
  await next();
}
