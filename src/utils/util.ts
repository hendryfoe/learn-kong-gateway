import * as jose from 'jose/index.ts';

export function cloneDeep(value: any) {
  return JSON.parse(JSON.stringify(value));
}

export async function sleep(ms: number) {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(true)
    }, ms);
  })
}

export async function signJWT(payload: Record<any, any>) {
  const secret = new TextEncoder().encode(Deno.env.get('JWT_SECRET'));
  const jwtToken = await new jose.SignJWT(payload)
    .setProtectedHeader({ alg: 'HS256' })
    .setExpirationTime('5m')
    .setIssuer(Deno.env.get('JWT_ISSUER')!)
    .sign(secret);

  return jwtToken;
}

export async function verifyJWT(jwtToken: string) {
  const secret = new TextEncoder().encode(Deno.env.get('JWT_SECRET'));
  const result = await jose.jwtVerify(jwtToken, secret)
    .then(({ payload, protectedHeader }) => {
      // console.log(payload, protectedHeader)
      return true;
    })
    .catch(() => {
      return false;
    });

  return result;
}
