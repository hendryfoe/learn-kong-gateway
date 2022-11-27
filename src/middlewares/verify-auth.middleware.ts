import { Context, Status } from 'oak/mod.ts';
import { verifyJWT } from '../utils/util.ts';

export async function verifyAuthMiddleware(ctx: Context, next: () => Promise<unknown>) {
  const headers = ctx.request.headers;
  if (!headers.has('authorization')) {
    ctx.throw(Status.Unauthorized, 'Unauthorized');
  }
  const accessToken = headers.get('authorization')!;
  await verifyJWT(accessToken).catch((_) => {
    ctx.throw(Status.Unauthorized, 'Unauthorized');
  });
  await next();
}
