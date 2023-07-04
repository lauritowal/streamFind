import { useCallback, useState, useEffect } from "react";
import { Handle, Position } from "reactflow";
import FolderIcon from "@mui/icons-material/Folder";
import SettingsIcon from "@mui/icons-material/Settings";
import PlayIcon from "@mui/icons-material/PlayCircle";
import axios from "axios";
import Modal from "@mui/material/Modal";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import Button from "@mui/material/Button";
import IconButton from "@mui/material/IconButton";
import CloseIcon from "@mui/icons-material/Close";
import "../../index.css";

const handleStyle = { left: 10 };

function MsData({ data: { inputFiles, edges }, isConnectable, id }) {
  const onChange = useCallback((evt) => {
    console.log(evt.target.value);
  }, []);

  console.log(inputFiles);
  console.log(edges);
  const [stepName, setStepName] = useState("");
  const [openModal, setOpenModal] = useState(false);
  const [data, setData] = useState([]);

  const handleOpen = () => {
    setOpenModal(true);
  };

  const handleClose = () => {
    setOpenModal(false);
  };

  const style = {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    width: 1500,
    height: 700,
    bgcolor: "#c1eff9",
    border: "2px solid white",
    borderRadius: "25px",
    p: 5,
  };

  const sendFiles = () => {
    axios
      .post("http://127.0.0.1:8000/msdata", inputFiles)
      .then((response) => {
        // Handle success response
        console.log("Files sent successfully!", response.data);
        setOpenModal(true);
        setData(response.data);
      })
      .catch((error) => {
        // Handle error
        console.error("Error sending files:", error);
      });
  };

  return (
    <div>
      <FolderIcon
        style={{ fontSize: "3em", color: "orange", cursor: "pointer" }}
      />
      <div
        style={{
          position: "absolute",
          top: 0,
          left: 40,
        }}
      >
        <SettingsIcon fontSize="1" />
      </div>
      <Handle
        type="source"
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
        type="source"
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
        style={{
          background: edges.length > 0 ? "white" : "grey",
        }}
        position={Position.Top}
        id="b"
        isConnectable={isConnectable}
      >
        <p style={{ fontSize: "6px", position: "absolute", top: -12, left: 8 }}>
          input
        </p>
        {edges.length > 0 && (
          <PlayIcon
            onClick={sendFiles}
            style={{
              color: inputFiles.length > 0 ? "green" : "red",
              fontSize: "10px",
              position: "absolute",
              top: -2,
              left: -2,
              cursor: "pointer",
            }}
          />
        )}
      </Handle>
      <Modal
        open={openModal}
        onClose={handleClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <Box sx={style}>
          <IconButton
            aria-label="close"
            onClick={handleClose}
            sx={{
              position: "absolute",
              right: 8,
              top: 8,
            }}
          >
            <CloseIcon />
          </IconButton>
          <Typography id="modal-modal-title" variant="h9" component="h2">
            Analysis Table
          </Typography>
          <table className="table-container">
            <thead>
              <tr>
                <th>file</th>
                <th>Analysis</th>
                <th>Replicate</th>
                <th>Blank</th>
                <th>class</th>
                <th>polarity</th>
              </tr>
            </thead>
            <tbody>
              {data.map((item) => (
                <tr key={item.id}>
                  <td>{item.file}</td>
                  <td>{item.analysis}</td>
                  <td>{item.replicate}</td>
                  <td>{item.blank}</td>
                  <td>{item.type}</td>
                  <td>{item.polarity}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </Box>
      </Modal>
    </div>
  );
}

export default MsData;
