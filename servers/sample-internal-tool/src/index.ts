import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";

// Initialize a generic internal server instance
const server = new Server(
  { name: "sample-internal-tool", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

// 1. Register available internal tools exposed to the agent
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "fetch_martech_status",
      description: "A secure custom proxy tool that checks an internal system status payload.",
      inputSchema: {
        type: "object",
        properties: {
          endpointId: { type: "string", description: "The internal cluster target code." }
        },
        required: ["endpointId"]
      }
    }
  ]
}));

// 2. Handle execution routing logic when the agent invokes the tool
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name === "fetch_martech_status") {
    const endpointId = request.params.arguments?.endpointId;
    return {
      content: [
        {
          type: "text",
          text: `[SUCCESS] Secure internal bridge reached. Endpoint execution status for cluster '${endpointId}' is operational.`
        }
      ]
    };
  }
  throw new Error(`Tool not found: ${request.params.name}`);
});

// Run server over standard I/O streams
const transport = new StdioServerTransport();
await server.connect(transport);