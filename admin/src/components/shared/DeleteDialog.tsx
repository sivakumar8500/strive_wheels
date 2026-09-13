import { Dialog, DialogContent, DialogFooter } from "@/components/ui/dialog";
import FormDialogHeader from "./FormDialogHeader";
import { Button } from "../ui/button";

interface DeleteDialogProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  entityLabel?: string; // e.g. "goal", "user", "manager"
  entityName?: string; // e.g. the name to show in the dialog
  title?: string; // override dialog title
  message?: string; // override dialog message
}

const DeleteDialog = ({
  isOpen,
  onClose,
  onConfirm,
  entityLabel = "item",
  entityName = "",
  title,
  message,
}: DeleteDialogProps) => {
  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent
        showCloseButton={false}
        className="rounded-lg border-none p-4 shadow-xl sm:max-w-[425px]"
      >
        <FormDialogHeader
          title={
            title ||
            `Delete ${entityLabel.charAt(0).toUpperCase() + entityLabel.slice(1)}`
          }
          onClose={onClose}
        />
        <div className="py-4 text-center">
          <p className="text-base leading-relaxed font-medium text-slate-500">
            {message || (
              <>
                Are you sure you want to delete {entityLabel}{" "}
                <span className="font-black text-slate-900">{entityName}</span>?
                <br />
                <span className="mt-2 block text-sm font-bold tracking-widest text-red-400 uppercase opacity-80">
                  This action cannot be undone.
                </span>
              </>
            )}
          </p>
        </div>
        <DialogFooter className="mt-2 flex flex-col gap-4 sm:flex-row">
          <Button
            variant="outline"
            className="h-11 flex-1 rounded-xl border-gray-200 font-bold text-slate-500 hover:bg-slate-50"
            onClick={onClose}
          >
            Cancel
          </Button>
          <Button
            className="h-11 flex-1 rounded-xl border-none bg-red-500 text-sm font-black text-white shadow-lg transition-all hover:bg-red-600"
            onClick={onConfirm}
          >
            Delete
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

export default DeleteDialog;
