// typescript/utils/parsePaymentRequired.ts

export type ParseResult<T> =
  | { ok: true; value: T }
  | { ok: false; error: string };

function decodeBase64(input: string): string {
  // Node.js
  if (typeof Buffer !== "undefined") {
    return Buffer.from(input, "base64").toString("utf8");
  }
  // Browser fallback
  if (typeof atob !== "undefined") {
    return atob(input);
  }
  throw new Error("No base64 decoder available in this environment.");
}

/**
 * Parses the x402 PAYMENT-REQUIRED header:
 * base64(JSON) -> object
 */
export function parsePaymentRequiredHeader<T = unknown>(headerValue: string): ParseResult<T> {
  try {
    if (!headerValue || typeof headerValue !== "string") {
      return { ok: false, error: "Header value is missing or not a string." };
    }

    const json = decodeBase64(headerValue.trim());
    const value = JSON.parse(json) as T;

    return { ok: true, value };
  } catch (err) {
    return {
      ok: false,
      error: err instanceof Error ? err.message : "Unknown parse error",
    };
  }
}
