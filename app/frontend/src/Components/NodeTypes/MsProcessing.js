import { useCallback, useState } from "react";
import { Handle, Position } from "reactflow";
import QueryStatsIcon from "@mui/icons-material/QueryStats";
import SettingsIcon from "@mui/icons-material/Settings";
import PlayIcon from "@mui/icons-material/PlayCircle";
import axios from "axios";
import Typography from "@mui/material/Typography";
import IconButton from "@mui/material/IconButton";
import CloseIcon from "@mui/icons-material/Close";
import Modal from "@mui/material/Modal";
import Box from "@mui/material/Box";

const handleStyle = { left: 10 };

function MsData({
  data: { label, edges, processing, setNodes },
  isConnectable,
}) {
  const onChange = useCallback((evt) => {
    console.log(evt.target.value);
  }, []);
  console.log(processing);

  const [features, setFeatures] = useState("");
  const [openModal, setOpenModal] = useState(false);
  const style = {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    width: 1500,
    height: 700,
    bgcolor: "white",
    border: "2px solid white",
    borderRadius: "25px",
    p: 5,
  };

  const handleClose = () => {
    setOpenModal(false);
  };

  const getFeatures = () => {
    axios
      .post("http://127.0.0.1:8000/get_features", processing)
      .then((response) => {
        console.log("Getting features", response);
        setFeatures(response.data);
        console.log(features);
        setOpenModal(true);
      })
      .catch((error) => {
        console.error("Error sending files:", error);
      });
  };

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
        style={{ background: "white" }}
        position={Position.Left}
        isConnectable={isConnectable}
      >
        <p
          style={{ fontSize: "9px", position: "absolute", top: -12, left: -9 }}
        >
          in
        </p>
        <PlayIcon
          onClick={getFeatures}
          style={{
            color: processing.length > 0 ? "green" : "red",
            cursor: "pointer",
            fontSize: "10px",
            position: "absolute",
            top: -2,
            left: -2,
          }}
        />
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
      <Modal
        open={openModal}
        onClose={handleClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <Box sx={style}>
          <IconButton
            onClick={handleClose}
            aria-label="close"
            sx={{
              position: "absolute",
              right: 8,
              top: 8,
            }}
          >
            <CloseIcon />
          </IconButton>
          {Object.keys(features).map((key) => (
            <Typography key={key}>{`${key}: ${features[key]}`}</Typography>
          ))}
        </Box>
      </Modal>
    </div>
  );
}

export default MsData;
