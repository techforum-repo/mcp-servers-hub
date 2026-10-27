import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

// Initialize a generic internal server instance
const server = new McpServer({ name: "sample-internal-tool", version: "1.1.0" });

// Register available internal tools exposed to the agent. The zod schema is
// published to the client as JSON Schema and validated before the handler runs.
server.registerTool(
  "fetch_martech_status",
  {
    title: "Fetch MarTech status",
    description: "A secure custom proxy tool that checks an internal system status payload.",
    inputSchema: {
      endpointId: z
        .string()
        .regex(/^[A-Za-z0-9_-]{1,64}$/, "Use letters, digits, '-' or '_' (max 64)")
        .describe("The internal cluster target code."),
    },
    annotations: { readOnlyHint: true, openWorldHint: false },
  },
  async ({ endpointId }) => ({
    content: [
      {
        type: "text",
        text: `[SUCCESS] Secure internal bridge reached. Endpoint execution status for cluster '${endpointId}' is operational.`,
      },
    ],
  })
);

// Run server over standard I/O streams
const transport = new StdioServerTransport();
await server.connect(transport);
