import { useCallback } from "react";
import { Handle, Position } from "reactflow";
import QueryStatsIcon from "@mui/icons-material/QueryStats";
import SettingsIcon from "@mui/icons-material/Settings";

const handleStyle = { left: 10 };

function MsData({ data, isConnectable }) {
  const onChange = useCallback((evt) => {
    console.log(evt.target.value);
  }, []);

  return (
    <div>
      <QueryStatsIcon style={{ fontSize: "3em", cursor: "pointer" }} />
      <div
        style={{
          position: "absolute",
          top: 0,
          left: 0,
        }}
      >
        <SettingsIcon fontSize="1" />
      </div>
      <Handle
        type="target"
        style={{ background: "green" }}
        position={Position.Left}
        isConnectable={isConnectable}
      >
        <p
          style={{ fontSize: "9px", position: "absolute", top: -12, left: -9 }}
        >
          in
        </p>
      </Handle>
      <Handle
        type="target"
        style={{ background: "blue" }}
        position={Position.Right}
        id="a"
        isConnectable={isConnectable}
      >
        <p style={{ fontSize: "9px", position: "absolute", top: -12, left: 8 }}>
          out
        </p>
      </Handle>
      <Handle
        type="target"
        style={{ background: "grey" }}
        position={Position.Top}
        id="b"
        isConnectable={isConnectable}
      >
        <p style={{ fontSize: "9px", position: "absolute", top: -12, left: 9 }}>
          input
        </p>
      </Handle>
    </div>
  );
}

export default MsData;
